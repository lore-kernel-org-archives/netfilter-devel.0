From: Patrick McHardy <kaber@trash.net>
Subject: Re: ip_conntrack_proto_sctp INIT_ACK messages dropped
Date: Wed, 23 Feb 2005 16:53:11 +0100
Message-ID: <421CA6E7.6030508@trash.net>
References: <003001c51910$8d3d1990$320aa8c0@blueslicemtl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: 'Harald Welte' <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	'Kiran Kumar Immidi' <immidi@spymac.com>
To: Ariel Rosenblatt <ariel@blueslice.com>
In-Reply-To: <003001c51910$8d3d1990$320aa8c0@blueslicemtl>
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

Ariel Rosenblatt wrote:
>>Still we should do the best we can, which seems to be makeing
>>sure the restart is valid before changing the tags. I'll see
>>if I can come up with a patch.
> 
> Please let me know if I can help with this and also the multi homing
> support.

Unfortunately we can't use the Tie-Tags since the format and content
of the cookie is up to its sender. We could probably add our own data
to the cookie, but I don't have time to play with this currently.

Regards
Patrick
