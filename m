From: Deti Fliegl <deti@fliegl.de>
Subject: Re: problem with conntrack utility and kernel 2.6.14
Date: Sat, 29 Oct 2005 17:44:07 +0200
Message-ID: <436398C7.4070402@fliegl.de>
References: <4361EAAB.1090206@fliegl.de>	<4361F6DF.3050106@eurodev.net>	<43621028.40705@fliegl.de>	<43627A8F.9060307@eurodev.net>	<436281BB.2010100@fliegl.de>
	<436373E8.7040606@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>,
	netfilter-devel@lists.netfilter.org
In-Reply-To: <436373E8.7040606@eurodev.net>
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

Hi Pablo,

the good thing about your latest patch is that the conntrack tool no 
longer crashes the kernel same test conditions as yesterday: 800Mbit/s 
Bandwidth, 25000 conntrack entries, @1000 connections/s).
Very weird...

Deti
