From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: change in behavior of OUTPUT chain rule in 2.6.19
Date: Thu, 31 May 2007 21:49:35 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0705312149090.11140@yvahk01.tjqt.qr>
References: <45819829.2060806@laurelnetworks.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Mike Accetta <maccetta@laurelnetworks.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45819829.2060806@laurelnetworks.com>
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


On Dec 14 2006 13:30, Mike Accetta wrote:
>
> Between 2.6.18 and 2.6.19 (and 2.6.19.1) we've observed that a reject rule on
> the OUTPUT chain no longer causes a connection attempt to abort immediately
> with "Connection refused".  As a specific example, this rule
>
> iptables -A  OUTPUT -p tcp --destination-port 23 \
> --destination 10.0.20.1  -j REJECT --reject-with tcp-reset

I cannot reproduce this with 2.6.20.2. Have you tried any newer kernel?


	Jan
-- 
