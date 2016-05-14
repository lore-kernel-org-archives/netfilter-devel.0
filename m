From: Rolf Fokkens <rolf@rolffokkens.nl>
Subject: [PATCH] CT: add "none" as parameter for --ctevents
Date: Sat, 14 May 2016 18:22:42 +0200
Message-ID: <533765ae-2261-0b57-a5ae-8b8c0feba12a@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36583 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbcENQWq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 May 2016 12:22:46 -0400
Received: by mail-wm0-f68.google.com with SMTP id w143so9478857wmw.3
        for <netfilter-devel@vger.kernel.org>; Sat, 14 May 2016 09:22:45 -0700 (PDT)
Received: from home07.rolf-en-monique.lan (5ED48DA7.cm-7-5c.dynamic.ziggo.nl. [94.212.141.167])
        by smtp.gmail.com with ESMTPSA id w3sm24406845wjt.0.2016.05.14.09.22.43
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Sat, 14 May 2016 09:22:43 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I noticed increasing CPU utilisation by conntrackd, which resulted from 
our Zabbix monitoring. Zabbix creates lots of short-lived tcp 
connections, which of course has impact on the number of connections and 
conntrackd. The solutions is the following iptables command:

iptables -I PREROUTING -t raw -p tcp --dport 10050 -j CT --ctevents none

So Zabbix connections are welcome in the connection tracking table, but 
there's no need to synchronize them with the other firewall.

This need some iptables patching, it was brought up before: 
http://permalink.gmane.org/gmane.comp.security.firewalls.netfilter.devel/37745

The solution didn't work though: during processing a mask of 0 is 
interpreted as "not specified" which in turn is interpreted as "all 
events". So I got it to work with a trick: I use 0x8000 to specify 
"none". It will not be misunderstood as "not specified", bug bit 16 will 
never match any (existing) events. The patch is below.

I think there's a better solution than misusing an unused bit, but the 
kernel (Latest Centos kernel that is) is happy with this, and so am I.

Rolf

[rolf.fokkens@th-dev-pkgbuilder ~]$ cat 
rpmbuild/SOURCES/iptables-1.4.21-ctevents_none.patch
--- iptables-1.4.21/extensions/libxt_CT.c.ctevents_none 2013-11-22 
12:18:13.000000000 +0100
+++ iptables-1.4.21/extensions/libxt_CT.c    2016-05-14 
12:43:56.368676956 +0200
@@ -95,6 +95,8 @@
  static uint32_t ct_parse_events(const struct event_tbl *tbl, unsigned 
int size,
                  const char *events)
  {
+    if (strcmp(events, "none") == 0) return 0x8000;
+
      char str[strlen(events) + 1], *e = str, *t;
      unsigned int mask = 0, i;

@@ -121,6 +123,11 @@
      unsigned int i;

      printf(" %s ", pfx);
+    if ((mask & ~0x8000) == 0) {
+        printf ("none");
+        return;
+    }
+
      for (i = 0; i < size; i++) {
          if (mask & (1 << tbl[i].event)) {
              printf("%s%s", sep, tbl[i].name);
--- iptables-1.4.21/extensions/libxt_CT.man.ctevents_none 2013-11-22 
12:18:13.000000000 +0100
+++ iptables-1.4.21/extensions/libxt_CT.man    2016-05-14 
12:34:29.723349847 +0200
@@ -15,6 +15,8 @@
  event types are: \fBnew\fP, \fBrelated\fP, \fBdestroy\fP, \fBreply\fP,
  \fBassured\fP, \fBprotoinfo\fP, \fBhelper\fP, \fBmark\fP (this refers to
  the ctmark, not nfmark), \fBnatseqinfo\fP, \fBsecmark\fP (ctsecmark).
+Alternatively the set of events can be specified as \fBnone\fP, which
+explicitly specifies not to generate any event at all.
  .TP
  \fB\-\-expevents\fP \fIevent\fP[\fB,\fP...]
  Only generate the specified expectation events for this connection.
[rolf.fokkens@th-dev-pkgbuilder ~]$

