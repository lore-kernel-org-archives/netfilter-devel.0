From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: PPTP conntrack/NAT Problems
Date: Thu, 26 Feb 2004 01:18:22 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402260112110.1149-100000@filer.marasystems.com>
References: <Pine.LNX.4.58.0402251710390.29202@mastermind.inside.guardiandigital.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Ryan W. Maple" <ryan@guardiandigital.com>
In-Reply-To: <Pine.LNX.4.58.0402251710390.29202@mastermind.inside.guardiandigital.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 25 Feb 2004, Ryan W. Maple wrote:

> That much I know -- I was just wondering exactly what CVS revisions
> comprised "version 1.13" of the PPTP patches so I could determine if I in
> fact had "version 1.13" or not.

The CVS revision of Version 1.13 of the patch is 1.13.

> Guess it's back to the drawing board.  I thought the issue I was having
> was fixed in "version 1.13" but I guess not.

Probably.

> Is there anything else you need to do on the machine to allow incoming
> PPTP connections (to pptpd) while NAT'ing outbound PPTP?

You should not need more than to allow the incoming PPTP connection and 
RELATED traffic.. but it is entirely possible there is some conflict or 
missing details for handling local pptp endpoints.

Regards
Henrik
