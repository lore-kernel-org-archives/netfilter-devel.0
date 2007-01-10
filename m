From: Patrick McHardy <kaber@trash.net>
Subject: Re: Iptable loop during kernel startup
Date: Wed, 10 Jan 2007 13:49:34 +0100
Message-ID: <45A4E0DE.9010209@trash.net>
References: <BFECAF9E178F144FAEF2BF4CE739C668030B5907@exmail1.se.axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: 'Linux Kernel Mailing List' <linux-kernel@vger.kernel.org>,
	Edgar Iglesias <edgar.iglesias@axis.com>,
	'Netfilter Development Mailinglist'
	<netfilter-devel@lists.netfilter.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932801AbXAJMtg@vger.kernel.org>
To: Mikael Starvik <mikael.starvik@axis.com>
In-Reply-To: <BFECAF9E178F144FAEF2BF4CE739C668030B5907@exmail1.se.axis.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Mikael Starvik wrote:
>>Which iptables/kernel versions are you using?
> 
> 
> 2.6.19. After further testing it seams to be a compiler/CPU issue. The exact
> 
> same kernelconfig works on ARM. So I have to dig some...

On which architecture did the error occur? It could be related
to 32 bit compat issues ..
