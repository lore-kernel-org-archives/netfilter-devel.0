From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Subject: Re: reverse NATing
Date: Fri, 18 Mar 2005 13:35:57 -0500
Message-ID: <debc30fc05031810356f0fc1ee@mail.gmail.com>
References: <537f59d10503172337941a6a4@mail.gmail.com>
Reply-To: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Vinay Reddy <vinayvinay@gmail.com>
In-Reply-To: <537f59d10503172337941a6a4@mail.gmail.com>
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

I think you are talking about what seems to be the connection
tracking, once a packet match a rule in the nat table it will use that
rule until the connection is closed and in both sides.


On Fri, 18 Mar 2005 13:07:33 +0530, Vinay Reddy <vinayvinay@gmail.com> wrote:
> Hi,
> I would like to know where exactly reverse mapping(packets coming from
> outside to the internal network) is done in the case of SNAT? From the
> netfilter documentation, it seems to be done in the POST_ROUTING hook.
> Is it true?
> Logically I would expect the packet to be reverse mapped in the
> pre-routing state itself. Why would one want to reverse map it in post
> routing? I am sure I am missing something. Could anyone please
> enlighten me?
> 
> Any help would be appreciated.
> 
> Regards,
> Vinay
> 
>
