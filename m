From: "Ariel Rosenblatt" <ariel@blueslice.com>
Subject: RE: ip_conntrack_proto_sctp INIT_ACK messages dropped
Date: Tue, 22 Feb 2005 13:58:44 -0500
Message-ID: <003001c51910$8d3d1990$320aa8c0@blueslicemtl>
References: <Pine.LNX.4.62.0502221934070.3531@kaber.coreworks.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: 'Harald Welte' <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	'Kiran Kumar Immidi' <immidi@spymac.com>
To: "'Patrick McHardy'" <kaber@trash.net>
In-Reply-To: <Pine.LNX.4.62.0502221934070.3531@kaber.coreworks.de>
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



> -----Original Message-----
> From: Patrick McHardy [mailto:kaber@trash.net]
> Sent: Tuesday, February 22, 2005 1:44 PM
> To: Ariel Rosenblatt
> Cc: 'Harald Welte'; netfilter-devel@lists.netfilter.org; 'Kiran Kumar
> Immidi'
> Subject: RE: ip_conntrack_proto_sctp INIT_ACK messages dropped
> 
> On Tue, 22 Feb 2005, Ariel Rosenblatt wrote:
> > As for saving Tag_A', this can be done at the INIT or the INIT-ACK.
> Saving
> > it at the INIT is bad as you mentioned before. Saving it during the
> INIT-ACK
> > is also bad because a malicious INIT-ACK can make Tag_A'' to be saved
> > causing the conntrack module to discard valid traffic tagged as Tag_A'.
> 
> In all these cases an attacker needs to know the tags, in which case
> he can simply reset the association. We are trying to protect against
> someone guessing src/dst/ports.

You are right!

> Still we should do the best we can, which seems to be makeing
> sure the restart is valid before changing the tags. I'll see
> if I can come up with a patch.

Please let me know if I can help with this and also the multi homing
support.

Thanks,

- Ariel

> Regards
> Patrick
> 
> 
