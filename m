From: Patrick McHardy <kaber@trash.net>
Subject: Re: ip_conntrack_proto_sctp INIT_ACK messages droppedg
Date: Tue, 15 Feb 2005 17:08:44 +0100
Message-ID: <42121E8C.2070505@trash.net>
References: <001d01c50dda$f317c4e0$320aa8c0@blueslicemtl>
	<20050214232045.GJ3829@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050214232045.GJ3829@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:

>On Tue, Feb 08, 2005 at 07:37:22AM -0500, Ariel Rosenblatt wrote:
>
>>The following patch seems to solve the problem, the INIT "init_tag" is now
>>saved properly for an ESTABLISHED sctp association. The "init_tag" (of an
>>INIT message) wasn't being saved in the proper direction, causing the
>>INIT_ACK to be dropped while verifying the tag ("vtag") at the beginning of
>>sctp_packet().
>>
>
>Thanks for your patch.  Patrick, would you please include the patch with
>your next patches to davem?
>
Are you sure it is correct ? RFC2960 §5.2.2-5.2.4 talks about how to handle
unexpected INIT and INIT_ACKs. It says:

   After sending out the INIT ACK, the endpoint shall take no further
   actions, i.e., the existing association, including its current state,
   and the corresponding TCB MUST NOT be changed.

I sounds to me like we can translate this to "the conntrack must not change".

Regards
Patrick
