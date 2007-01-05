From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Patch: add id to libnetfilter_conntrack XML export
Date: Fri, 05 Jan 2007 15:45:29 +0100
Message-ID: <459E6489.9070307@netfilter.org>
References: <200701051427.37273.victor.stinner@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Victor Stinner <victor.stinner@inl.fr>
In-Reply-To: <200701051427.37273.victor.stinner@inl.fr>
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

Victor Stinner wrote:
> I heard that connection identifiers may disappear. Is it true? I like unique 
> identifier because it's small (only 32 bits) and easy to manipulate. It's 
> hard to identify a connection without such identifier.

Indeed, it's planned to get rid of the id. We resolved that the tuple
src/dst/port-src/port-dst/l3protonum/l4protonum is enough to identify a
conntrack.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
