From: Amin Azez <azez@ufomechanic.net>
Subject: Re: new code; iptables-xml for iptables package.
Date: Fri, 10 Nov 2006 14:29:38 +0000
Message-ID: <45548CD2.5090407@ufomechanic.net>
References: <455311B5.5000600@ufomechanic.net>
	<455374BE.9050507@trash.net>	<455457C8.4030205@ufomechanic.net>
	<45547982.2070606@trash.net>	<45547E94.1040100@ufomechanic.net>
	<455483D9.6090003@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000201040207010604040207"
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <455483D9.6090003@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------000201040207010604040207
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

* Patrick McHardy wrote, On 10/11/06 13:51:
> Amin Azez wrote:
>> As for the spacing - guilt - I used the wrong indent options obviously
>> :-) fixed now
> 
> Thanks, now all I need is a patch to the Makefile to actually compile
> this thing :)
> 
> 

:-)

Here 'tis.

Sam

--------------000201040207010604040207
Content-Type: text/x-patch;
 name="iptables-xml-makefile.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iptables-xml-makefile.patch"

--- Makefile.noxml	2006-04-10 16:14:39.000000000 +0100
+++ Makefile	2006-04-10 16:19:38.000000000 +0100
@@ -43,9 +43,9 @@
 
 # No longer experimental.
 ifneq ($(DO_MULTI), 1)
-EXTRAS+=iptables-save iptables-restore
+EXTRAS+=iptables-save iptables-restore iptables-xml
 endif
-EXTRA_INSTALLS+=$(DESTDIR)$(BINDIR)/iptables-save $(DESTDIR)$(BINDIR)/iptables-restore $(DESTDIR)$(MANDIR)/man8/iptables-restore.8 $(DESTDIR)$(MANDIR)/man8/iptables-save.8
+EXTRA_INSTALLS+=$(DESTDIR)$(BINDIR)/iptables-save $(DESTDIR)$(BINDIR)/iptables-restore $(DESTDIR)$(BINDIR)/iptables-xml $(DESTDIR)$(MANDIR)/man8/iptables-restore.8 $(DESTDIR)$(MANDIR)/man8/iptables-save.8
 
 ifeq ($(DO_IPV6), 1)
 EXTRAS+=ip6tables ip6tables.o ip6tables.8
@@ -117,7 +117,7 @@
 	$(CC) $(CFLAGS) -DIPT_LIB_DIR=\"$(IPT_LIBDIR)\" -c -o $@ $<
 
 ifeq ($(DO_MULTI), 1)
-iptables: iptables-multi.c iptables-save.c iptables-restore.c iptables-standalone.c iptables.o $(STATIC_LIBS) libiptc/libiptc.a
+iptables: iptables-multi.c iptables-save.c iptables-restore.c iptables-xml.c iptables-standalone.c iptables.o $(STATIC_LIBS) libiptc/libiptc.a
 	$(CC) $(CFLAGS) -DIPTABLES_MULTI -DIPT_LIB_DIR=\"$(IPT_LIBDIR)\" $(LDFLAGS) -o $@ $^ $(LDLIBS)
 else
 iptables: iptables-standalone.c iptables.o $(STATIC_LIBS) libiptc/libiptc.a
@@ -158,6 +158,19 @@
 	cp $< $@
 endif
 
+iptables-xml: iptables-xml.c #iptables.o # $(STATIC_LIBS) libiptc/libiptc.a
+	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS)
+
+ifeq ($(DO_MULTI), 1)
+$(DESTDIR)$(BINDIR)/iptables-xml: iptables-xml
+	@[ -d $(DESTDIR)$(BINDIR) ] || mkdir -p $(DESTDIR)$(BINDIR)
+	ln -sf $< $@
+else
+$(DESTDIR)$(BINDIR)/iptables-xml: iptables-xml
+	@[ -d $(DESTDIR)$(BINDIR) ] || mkdir -p $(DESTDIR)$(BINDIR)
+	cp $< $@
+endif
+
 ip6tables.o: ip6tables.c
 	$(CC) $(CFLAGS) -DIP6T_LIB_DIR=\"$(IPT_LIBDIR)\" -c -o $@ $<
 

--------------000201040207010604040207--
