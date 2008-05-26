From: Patrick McHardy <kaber@trash.net>
Subject: [ANNOUNCE] Release of iptables 1.4.1-rc2
Date: Mon, 26 May 2008 15:01:07 +0200
Message-ID: <483AB493.6010503@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060609030108080601030504"
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	"'netfilter@vger.kernel.org'" <netfilter@vger.kernel.org>,
	Netfilter Core Team <coreteam@netfilter.org>
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------060609030108080601030504
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

The netfilter coreteam proudly presents:

     iptables version 1.4.1-rc2

This release candidate fixes an incorrect assumption about /bin/sh
in the new build system and allows to specify the REDIRECT --to-port
symbolically.

Version 1.4.1-rc2 can be obtained from (please note that the
webpage hasn't been rebuilt yet, but will be shortly):

http://www.netfilter.org/projects/iptables/downloads.html
ftp://ftp.netfilter.org/pub/iptables/
git://git.netfilter.org/iptables.git

If nothing bad happens, I'll release the final 1.4.1 by next
week.

Please note: the iptables.git repository history has been
cleaned up to remove the certificate mess from committer
names and use correct author names. This unfortunately means
that you have to reclone it completely. Sorry about this,
in the future this shouldn't happen again.

On behalf of the Netfilter Core Team.
Happy testing!


--------------060609030108080601030504
Content-Type: text/plain;
 name="changes-iptables-1.4.1-rc2.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="changes-iptables-1.4.1-rc2.txt"

Kristof Provost (1):
      REDIRECT: Allow symbolic port in REDIRECT --to-port

Thomas Jacob (1):
      Don't assume /bin/sh is bash


--------------060609030108080601030504--
