From: Patrick Schaaf <bof@bof.de>
Subject: Re: Netfilter won't forward if tcp packets contain large payloads
Date: Mon, 10 Mar 2003 21:36:37 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030310203637.GB8066@oknodo.bof.de>
References: <02d301c2e4d0$69fd65a0$0a02010a@danbeck> <006d01c2e73d$1dceab20$0a02010a@danbeck>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Daniel Beckham <danbeck-netfilter-devel@dealnews.com>
Content-Disposition: inline
In-Reply-To: <006d01c2e73d$1dceab20$0a02010a@danbeck>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, Mar 10, 2003 at 01:41:55PM -0600, Daniel Beckham wrote:
> I haven't seen anyone comment on this, not even a "ask the users mailing
> list" response.   Is this something no one can answer, or did my previous
> message fail to get through?

Your message got through. You already mentioned that you went through
your setup on the user mailing list, so you were spared that comment.

Regarding your problem, I have only a prediction to make: in the end
it will have something to do with MTU mismatches. The symptoms you
describe fit that guess, in any case.

Debugging of tunnel setups / MTU problems is not the strength of this
mailing list, nor its purpose. Concrete fixing of already diagnosed
faults in netfilter / iptables is, as well as concrete proposals and
activities of improving the code.

I hope that this can explain the silence you got. I'm sorry I don't
have to offer more than this explanation.

best regards
  Patrick
