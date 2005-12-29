From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: Re: STring Replacement Patch [Quick Response]
Date: Thu, 29 Dec 2005 12:43:34 +0100
Message-ID: <43B3CBE6.1090908@eurodev.net>
References: <20051229104208.27463.qmail@web35912.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, rob@sterenborg.info,
	george.john@ch.easynet.net, mbr@cipherdyne.org,
	ishwar@pali.cps.cmich.edu, netfilter@lists.netfilter.org
Return-path: <netfilter-bounces@lists.netfilter.org>
To: Noman Liaquat <khankhn1@yahoo.com>
In-Reply-To: <20051229104208.27463.qmail@web35912.mail.mud.yahoo.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Noman Liaquat wrote:
> I  have downloaded the version of patch-o-matic-ng
> from netfilter websites and now my patch of string
> controlling is working, below command is the proof of
> that

the string match is available since kernel 2.6.14, so you don't need
pom-ng in any way.

> #iptables -A FORWARD -m string --algo bm --string
> "hello" -j DROP
> 
> ok that is fine. is there any way to alter that
> packet. to replace--string
> is there any patch available, if yes so how i can
> implement that patch. 

No, this functionality isn't implemented yet: The only sane way to do
this that I see at the moment is implementing a target called `STRING'.
Matches don't allow packet modifications. See the API requirements:

static int match(const struct sk_buff *skb, ...)
                  ^^^

So, such target must implement the same features than the current
`string' match does plus the --replace-string thing.

-- 
Pablo
