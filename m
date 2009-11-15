From: basteon <basteon@gmail.com>
Subject: iptables: iptc_init segfault
Date: Sun, 15 Nov 2009 17:09:33 +1000
Message-ID: <328fe7150911142309r7f3f3dd1mcaeb400a65947666@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:43274 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbZKOHJ2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 15 Nov 2009 02:09:28 -0500
Received: by iwn8 with SMTP id 8so3582157iwn.33
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Nov 2009 23:09:34 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

g'time of day to every1,
I tried todo iptables initailazation in my application, but
untortunately received seghault, why it's happening?
Which's way I can realy initialize libiptq and xtables in my program?
int main(int argc, char *argv[]){
char **table;
table = &argv[2];
struct iptc_handle **handle;
printf("A %s\n",*table);
*handle = iptc_init(*table);
printf("B\n");
}
