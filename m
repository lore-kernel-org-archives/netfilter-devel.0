From: ChungLiang <david@cobra.ee.ntu.edu.tw>
Subject: Re: L2TP protocol source port number changed
Date: Thu, 22 May 2003 14:46:13 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3ECC7235.9070606@cobra.ee.ntu.edu.tw>
References: <3ECC5A67.5000803@cobra.ee.ntu.edu.tw> <20030522055921.GA24297@oknodo.bof.de> <3ECC6D75.3000708@cobra.ee.ntu.edu.tw> <20030522063017.GC24297@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Dear Patrick,

	Yes, that could be done in the rules one way or another. What I am
wondering is that the rules are the same in both routers with same
kernel version. So I am curious what compiler option or something needs
to be set to achieve the result. Thanks.

	Best regards,
	ChungLiang

Patrick Schaaf wrote:
>>	Now I have build my own linux router and found out the second computer
>>will not have the source port staying at 1701 but changing to 1024 by
>>the NAT. I am wondering what should I do to make this go away and stay
>>at 1701. Thanks.
> 
> 
> NOW I get you. Easy: change your NAT rules suitably. All decisions about
> WHAT should be NATted, are made by YOUR rules.
> 
> If you don't know how to do that, please go ask the
> netfilter@lists.netfilter.org mailing list.
> It is now not a _development_ question.
> 
> best regards
>   Patrick
> 
> 
