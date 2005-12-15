From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] connbytes match connbytes-direction argument
Date: Wed, 14 Dec 2005 18:24:03 -0800
Message-ID: <20051215022403.GA7068@linuxace.com>
References: <20051215015748.GA6699@linuxace.com> <43A0CF5E.40204@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <43A0CF5E.40204@trash.net>
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

On Thu, Dec 15, 2005 at 03:05:18AM +0100, Patrick McHardy wrote:
> Phil Oester wrote:
> >Connbytes match should accept the full connbytes-direction argument
> >as the help notes.  At present, it only accepts 'connbytes-dir'.
> >This closes bugzilla #410.
> 
> In the version I have both the help text and the manpage only
> mention --connbytes-dir.

Yup, this was fixed on 12/5...appologies for the noise.

Phil
