From: Patrick McHardy <kaber@trash.net>
Subject: Re: [POM] MMS conntrack/NAT update
Date: Wed, 10 May 2006 07:49:44 +0200
Message-ID: <44617EF8.7030906@trash.net>
References: <11471772191487-git-send-email-heitzenberger@astaro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Holger Eitzenberger <heitzenberger@astaro.com>
In-Reply-To: <11471772191487-git-send-email-heitzenberger@astaro.com>
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

Holger Eitzenberger wrote:
> Hi,
> 
> what follows are two small changes to the MMS conntrack/NAT helper.
> 
> The first patch simply removes trailing whitespace and is therefore
> just janitorial work.
> 
> The second patch adapts the helper to make it work with kernel
> version 2.6.15.y.  It seems rather large, but it all boils down to the
> expectation refcounting changes.  The other changes result from the
> fact that I inverted an if-conditional to avoid a rather large if-block.
> Please take a look at the refcounting changes.


Both look good, thanks Holger.
