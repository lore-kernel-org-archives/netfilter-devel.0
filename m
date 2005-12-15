From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] connbytes match connbytes-direction argument
Date: Thu, 15 Dec 2005 03:05:18 +0100
Message-ID: <43A0CF5E.40204@trash.net>
References: <20051215015748.GA6699@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20051215015748.GA6699@linuxace.com>
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

Phil Oester wrote:
> Connbytes match should accept the full connbytes-direction argument
> as the help notes.  At present, it only accepts 'connbytes-dir'.
> This closes bugzilla #410.

In the version I have both the help text and the manpage only
mention --connbytes-dir.
