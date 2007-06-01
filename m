From: Patrick McHardy <kaber@trash.net>
Subject: Re: H.323 behavior
Date: Fri, 01 Jun 2007 17:38:22 +0200
Message-ID: <46603D6E.9040606@trash.net>
References: <925A849792280C4E80C5461017A4B8A210B7F8@mail733.InfraSupportEtc.com>	<465E506D.6060008@trash.net>
	<BAY139-DAV1488834AE2E507BE9E4BDFB32D0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Greg Scott <GregScott@InfraSupportEtc.com>
To: Jing Min Zhao <zhaojingmin@hotmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <BAY139-DAV1488834AE2E507BE9E4BDFB32D0@phx.gbl>
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

Jing Min Zhao wrote:
> 
>> It would probably make sense to destroy the connection when we seen
>> a CloseLogicalChannel or CloseLogicalChannelAck message to deal with
>> this kind of problem.
>>
> 
> Sometimes when people change codec, for example, from voice to T.38 fax,
> they also close channels and open channels, but the H.245 connection
> doesn't diconnect. So better to wait for the connection disconnect
> itself or at least disconnect upon EndSessionCommand.


CloseLogicalChannel might not be the right message (its been a while
since I last did something with H.323), but at least when we know for
sure the connection is closed we could kill it instead of waiting for
the timeout.
