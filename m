From: allen <aef@prismnet.com>
Subject: Re: [NEW EXTENSION] Condition Match
Date: Tue, 29 Oct 2002 22:43:07 -0600
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200210292243.07631.aef@prismnet.com>
References: <3DBED94E.1030107@videotron.ca>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Stephane Ouellette <ouellettes@videotron.ca>,
	netfilter-devel@lists.netfilter.org
In-Reply-To: <3DBED94E.1030107@videotron.ca>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org



On Tuesday 29 October 2002 12:54 pm, Stephane Ouellette wrote:
>    I developped last week a new extension to Netfilter in order to
> enable or disable a set of rules using /proc files.


Yeah, as others have said, the idea is definitely cool.

I hate to admit that I might use it this way.  God help me...

I'm having visions of debugging impossibly complex
booboo's, and chasing after phantom problems that
appear and disappear and not remembering that
I or someone had done or could have done this.

Can you think of a way to implement far greater
"manageability"

?

Or what are your thoughts about that ?

Maybe it is a "user-be-ware" thing best left to
some odd application to keep track of.

Hmn...

But... the "rules" would appear though... right ?

With an "iptables -L" ?

And current "state" ?

-AEF
