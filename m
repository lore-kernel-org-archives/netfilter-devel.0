From: "Mikael Starvik" <mikael.starvik@axis.com>
Subject: RE: Iptable loop during kernel startup
Date: Wed, 10 Jan 2007 14:00:05 +0100
Message-ID: <BFECAF9E178F144FAEF2BF4CE739C668030B5909@exmail1.se.axis.com>
References: <BFECAF9E178F144FAEF2BF4CE739C668044DEB69@exmail1.se.axis.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
	"Edgar Iglesias" <edgar.iglesias@axis.com>,
	"'Netfilter Development Mailinglist'"
	<netfilter-devel@lists.netfilter.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932802AbXAJNAT@vger.kernel.org>
To: "'Patrick McHardy'" <kaber@trash.net>,
	"Mikael Starvik" <mikael.starvik@axis.com>
In-Reply-To: <BFECAF9E178F144FAEF2BF4CE739C668044DEB69@exmail1.se.axis.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

The architecture is called CRIS. Its a straightforward 32-bit only arch. The

only special about this architecture that it doesn't force any alignment of 
data (so a packed struct and an unpacked struct is always the same).

/Mikael
-----Original Message-----
From: Patrick McHardy [mailto:kaber@trash.net] 
Sent: Wednesday, January 10, 2007 1:50 PM
To: Mikael Starvik
Cc: 'Linux Kernel Mailing List'; Edgar Iglesias; 'Netfilter Development
Mailinglist'
Subject: Re: Iptable loop during kernel startup


Mikael Starvik wrote:
>>Which iptables/kernel versions are you using?
> 
> 
> 2.6.19. After further testing it seams to be a compiler/CPU issue. The
exact
> 
> same kernelconfig works on ARM. So I have to dig some...

On which architecture did the error occur? It could be related
to 32 bit compat issues ..
