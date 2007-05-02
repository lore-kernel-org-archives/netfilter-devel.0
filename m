From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] xx_nat_proto_gre: do not modify/corrupt GREv0 packets
 thought NAT
Date: Wed, 02 May 2007 14:25:27 +0200
Message-ID: <46388337.3060800@trash.net>
References: <00c501c7829e$6209edd0$061010ac@intranet.dti2.net>	<462DFD1D.1060706@trash.net>	<101c01c78829$24a70230$061010ac@intranet.dti2.net>	<4631DCA3.4020701@trash.net>
	<00ef01c788c1$e32a62e0$061010ac@intranet.dti2.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: "Jorge Boncompte [DTI2]" <jorge@dti2.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <00ef01c788c1$e32a62e0$061010ac@intranet.dti2.net>
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
> returns a wrong pointer to the GRE key of a version 0 packet thus
> corrupting
> the packet payload.
>    The intended behaviour for GREv0 packets is to act like
> nf_conntrack_proto_generic/nf_nat_proto_unknown so I have ripped the
> offending functions (not used anymore) and modified the xx_nat_proto_gre
> modules to not touch version 0 (non PPTP) packets.


Applied, thanks. I removed the FIXME though since its the intended
behaviour and not something that needs to be fixed. I'll push it
to -stable as well.
