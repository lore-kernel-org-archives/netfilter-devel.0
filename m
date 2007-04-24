From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] xx_nat_proto_gre: gre_key returns wrong pointer
Date: Tue, 24 Apr 2007 14:50:37 +0200
Message-ID: <462DFD1D.1060706@trash.net>
References: <00c501c7829e$6209edd0$061010ac@intranet.dti2.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: "Jorge Boncompte [DTI2]" <jorge@dti2.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <00c501c7829e$6209edd0$061010ac@intranet.dti2.net>
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

Jorge Boncompte [DTI2] wrote:
>    While porting some changes of the 2.6.21-rc7 pptp/proto_gre conntrack
> and nat modules to a 2.4.32 kernel I noticed that the gre_key function
> returns a wrong pointer to the GRE key of a version 0 packet. I fixed it
> the way below but I don't know if it is right way. The gre_csum function
> seems to have the same problem. If the problem is real and the solution
> right I can resend with a signed-off line.


Good catch. I think what it should do is not touch the key/checksum of
version 0 GRE packets at all since the intention is to behave identical
to nf_conntrack_proto_generic/nf_nat_proto_unknown in that case.

Its a bit more complicated to do this because we also need to avoid
altering the tuple in gre_unique_tuple. If you want to give it a try
please go ahead, otherwise I can look into it.
