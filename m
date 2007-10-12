From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFD] iptables:  mangle table obsoletes filter table
Date: Fri, 12 Oct 2007 16:03:25 +0200
Message-ID: <470F7EAD.5050605@trash.net>
References: <200710120031.42805.a1426z@gawab.com> <Pine.LNX.4.64.0710121449370.23981@fbirervta.pbzchgretzou.qr> <200710121630.29151.a1426z@gawab.com> <Pine.LNX.4.64.0710121533360.23981@fbirervta.pbzchgretzou.qr> <470F7B4B.2010609@trash.net> <Pine.LNX.4.64.0710121553450.23981@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Al Boldi <a1426z@gawab.com>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, netdev@vger.kernel.org,
	linux-net@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0710121553450.23981@fbirervta.pbzchgretzou.qr>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> On Oct 12 2007 15:48, Patrick McHardy wrote:
> 
>>The netlink based iptables successor I'm currently working on allows to
>>dynamically create tables with user-specified priorities and "built-in"
>>chains. The only built-in tables will be those that need extra
>>processing (mangle/nat). So it should be possible to set up tables
>>basically any way you desire.
> 
> 
> Will ebtables move a bit closer to iptables?


I didn't get to that part yet, but yes, thats one of the goals.
