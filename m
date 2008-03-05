From: Filippo Zangheri <filippo.zangheri@yahoo.it>
Subject: xtables-1.5.2 not working
Date: Wed, 05 Mar 2008 10:37:29 +0100
Message-ID: <47CE69D9.7090308@yahoo.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from n2a.bullet.mail.ac4.yahoo.com ([76.13.13.65]:34363 "HELO
	n2a.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758546AbYCEJoS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Mar 2008 04:44:18 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'm new to netfilter-dev ml and to netfilter development in general.
Today I'm testing xtables-1.5.2.

OS: Debian "Etch" 4.0

filippo@master:~/repos/xtables-dev$ uname -a
Linux master 2.6.24.3-fz-20080226 #1 SMP Tue Feb 26 15:12:50 CET 2008 i686 GNU/Linux

Before building xtables, I removed ip{,6}tables-1.3.6 (which is the version shipped with
my distro until now).

I cloned xtables-{dev,addons} git repos then built xtables without strange parameters:

../autogen.sh
../configure --prefix=/usr
make
sudo make install

I can see all libraries were successfully created in /usr/libexec/xtables, all
executables in /usr/{s,}bin, and all header files in /usr/include{,/libiptc}.

Now, all attempts to set an iptables rule fail with either segmentation fault:

filippo@master:~/repos/xtables-dev$ sudo /usr/sbin/iptables -A INPUT -i lo -j ACCEPT
Segmentation fault
filippo@master:~/repos/xtables-dev$ dmesg
iptables[19575]: segfault at 00000000 eip 0804d1b0 esp bfa585b0 error 6

or this kind of error message:

iptables-restore v1.5.2: Couldn't load target `standard':/usr/libexec/xtables/libipt_standard.so: cannot open shared object file: No such file or directory

Well, that's normal - there's no such library - so after issuing:

filippo@master:~/repos/xtables-dev$ sudo mv /usr/libexec/xtables/lib{xt,ipt}_standard.so

I get the following error message:

iptables-restore v1.5.2: Couldn't load target `standard':(null)


Any hint?
Thank you so much for the great job, and It would be really great if the
official development tree moved to Git.

Best regards.


-- 
Filippo Zangheri

GPG key ID: 0xE1D879FA
Key fingerprint: 816B CE57 D43C 0A47 EF35 3378 EA5F A72A E1D8 79FA
Key server: pgp.mit.edu

-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GE d- s+:- a-- C++ UL+++ P+ L+++ E-- W+ N* o-- K- w--- O-- M--
V- PS++ PE+ Y+ PGP++ t 5-- X++ R* tv b+ DI-- D---- G-- e++ h--
r++ z*
------END GEEK CODE BLOCK------


