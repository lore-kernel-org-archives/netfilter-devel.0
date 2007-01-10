From: "Mikael Starvik" <mikael.starvik@axis.com>
Subject: RE: Iptable loop during kernel startup
Date: Wed, 10 Jan 2007 12:29:15 +0100
Message-ID: <BFECAF9E178F144FAEF2BF4CE739C668030B5907@exmail1.se.axis.com>
References: <BFECAF9E178F144FAEF2BF4CE739C668044DEB07@exmail1.se.axis.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
	"Edgar Iglesias" <edgar.iglesias@axis.com>,
	"'Netfilter Development Mailinglist'"
	<netfilter-devel@lists.netfilter.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S964827AbXAJL3a@vger.kernel.org>
To: "'Patrick McHardy'" <kaber@trash.net>,
	"Mikael Starvik" <mikael.starvik@axis.com>
In-Reply-To: <BFECAF9E178F144FAEF2BF4CE739C668044DEB07@exmail1.se.axis.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

>Which iptables/kernel versions are you using?

2.6.19. After further testing it seams to be a compiler/CPU issue. The exact

same kernelconfig works on ARM. So I have to dig some...

/Mikael
