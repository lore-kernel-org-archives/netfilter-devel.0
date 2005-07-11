From: Roberto Nibali <ratz@tac.ch>
Subject: Re: SO_ORIGINAL_DST does not work in nat/OUTPUT anymore
Date: Mon, 11 Jul 2005 11:44:18 +0200
Message-ID: <42D23F72.5040103@tac.ch>
References: <42D12E28.7020707@hoelldampf.net>	<20050710153234.GM20465@sunbeam.de.gnumonks.org>	<42D14A6D.4000900@trash.net>	<Pine.LNX.4.61.0507101822200.9759@filer.marasystems.com>	<42D1608C.7040909@trash.net>	<20050710202359.GA6874@sunbeam.de.gnumonks.org>	<20050710222006.GA11812@linuxace.com>
	<42D1B52A.10200@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	Henrik Nordstrom <hno@marasystems.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42D1B52A.10200@trash.net>
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

Patrick McHardy wrote:
> Phil Oester wrote:
> 
>>I humbly re-resubmit my original patch.
> 
> 
> It doesn't apply to the current tree. I'm going to fix it up manually,
> but please base future patches on linus's latest tree.

... and for the 2.4.x case? I most certainly haven't had the time to test this
use case yet but the problems should be the same.

Cheers,
Roberto Nibali, ratz
-- 
-------------------------------------------------------------
addr://Rathausgasse 31, CH-5001 Aarau  tel://++41 62 823 9355
http://www.terreactive.com             fax://++41 62 823 9356
-------------------------------------------------------------
terreActive AG                       Wir sichern Ihren Erfolg
-------------------------------------------------------------
