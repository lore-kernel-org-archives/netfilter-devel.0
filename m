From: Patrick McHardy <kaber@trash.net>
Subject: Re: NOT in mport / multiport
Date: Mon, 08 Nov 2004 17:00:11 +0100
Message-ID: <418F980B.708@trash.net>
References: <418F5978.2010902@anduras.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Sven Anders <anders@anduras.de>
In-Reply-To: <418F5978.2010902@anduras.de>
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

Sven Anders wrote:

> I think ANY matching module should support negation of itself...
>
> (Any if any compatibilty with the user space program will break, why 
> not? We are useded to
> it - it does break every two versions of ip-tables...)

That's exactly the reason. and we try to make sure it doesn't
happen. Please let us know when compatibility broke for you.

Patrick
