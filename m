From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: adding field into conntrack
Date: Thu, 29 Jul 2004 10:29:43 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1091060982.28111.30.camel@bach>
References: <1091042173.4107fb7d2cabf@mail.crocetta.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: sandr8@crocetta.org
In-Reply-To: <1091042173.4107fb7d2cabf@mail.crocetta.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 2004-07-29 at 05:16, sandr8@crocetta.org wrote:
> Hi,
>  sorry to bother you.
> would you mind if i add two 32 bits fields to the cnntrack structure?
> 
> i can surround them with an ifdef to have them only if the module i am writing
> is configured. Their aim would be to count how many bytes were transmitted on
> each side of the connection.

Hi Alessandro,

	I believe there's already a patch like that, or one in progress. 
You're not the only one who want this.

Harald would know more...
Rusty.
-- 
Anyone who quotes me in their signature is an idiot -- Rusty Russell
