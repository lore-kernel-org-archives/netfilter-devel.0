From: Patrick McHardy <kaber@trash.net>
Subject: RE: ip_conntrack_proto_sctp INIT_ACK messages dropped
Date: Tue, 22 Feb 2005 19:44:07 +0100 (CET)
Message-ID: <Pine.LNX.4.62.0502221934070.3531@kaber.coreworks.de>
References: <002f01c518fc$510cb660$320aa8c0@blueslicemtl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: 'Harald Welte' <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	'Kiran Kumar Immidi' <immidi@spymac.com>
To: Ariel Rosenblatt <ariel@blueslice.com>
In-Reply-To: <002f01c518fc$510cb660$320aa8c0@blueslicemtl>
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

On Tue, 22 Feb 2005, Ariel Rosenblatt wrote:
> This is kind of what I had in mind. However, a malicious INIT-ACK, with
> knowledge about the saved tags (these can be easily sniffed) can cause the
> conntrack module to save a fictitious Tag_Z'' causing the conntrack to save
> Tag_A' and Tag_Z'', thus discarding the valid INIT-ACK with Init_Tag=Tag_Z'.
>
> Also, a malicious COOKIE-ECHO can cause the Tag_Z''' to be saved instead of
> Tag_Z', having the same effect as a malicious INIT-ACK.
>
> As for saving Tag_A', this can be done at the INIT or the INIT-ACK. Saving
> it at the INIT is bad as you mentioned before. Saving it during the INIT-ACK
> is also bad because a malicious INIT-ACK can make Tag_A'' to be saved
> causing the conntrack module to discard valid traffic tagged as Tag_A'.

In all these cases an attacker needs to know the tags, in which case
he can simply reset the association. We are trying to protect against
someone guessing src/dst/ports.

> It would seem that by keeping the Tag_A' used in the INIT (while Tag_A is
> still in use) just to match it to the Tag_A' that should be used in the
> INIT-ACK will solve the problem (kind of a two staged approach). However
> this "kept" Tag_A' (or Tag_Z' for the INIT-ACK) can be easily overwritten
> with a malicious INIT (or INIT-ACK), before the INIT-ACK arrives (or the
> COOKIE-ECHO is sent). Timers will help for this two phase approach. However,
> serious performance degradation will still be achieved if the vtags and
> tie-tags are known to the attacker.
>
> Tags (as well as cookies) can be sniffed, so malicious cookies can be
> generated to trick the connection tracking into believing that the
> association must be reset. The very fact that the connection tracking relies
> on these messages to save the tags is what causes this vulnerability.

Again, this is not what we are trying to protect against.

> However, as I stated before, without proper network layer authentication
> (e.g. IPSEC AH) SCTP endpoints are not exempt from masquerading attacks, and
> there is so much connection tracking can do to enhance the lack of transport
> layer security.

Still we should do the best we can, which seems to be makeing
sure the restart is valid before changing the tags. I'll see
if I can come up with a patch.

Regards
Patrick
