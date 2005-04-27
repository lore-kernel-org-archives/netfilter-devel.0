From: Patrick McHardy <kaber@trash.net>
Subject: Re: Status of owner-socketlookup
Date: Wed, 27 Apr 2005 16:04:48 +0200
Message-ID: <426F9C00.9000804@trash.net>
References: <Xine.LNX.4.44.0504270958400.17685-100000@thoron.boston.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: James Morris <jmorris@redhat.com>
In-Reply-To: <Xine.LNX.4.44.0504270958400.17685-100000@thoron.boston.redhat.com>
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

James Morris wrote:
> Also, I wonder, if we're doing the socket lookup early (in Netfilter), 
> perhaps there's some way of caching this so we don't have to do it again 
> later.

With NF_SK_HOOK(), filtering would happen in socket context, so
there is no need to cache it. Otherwise it makes sense I guess.

Regards
Patrick
