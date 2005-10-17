From: Philip Craig <philipc@snapgear.com>
Subject: Re: tcp match silently drops packets
Date: Mon, 17 Oct 2005 10:21:51 +1000
Message-ID: <4352EE9F.2020004@snapgear.com>
References: <4349D97A.9070708@snapgear.com>	<200510160751.j9G7ph5t009316@toshiba.co.jp>	<Pine.LNX.4.61.0510161931530.32106@filer.marasystems.com>
	<Pine.LNX.4.61.0510162247010.802@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0510162247010.802@filer.marasystems.com>
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

On 10/17/2005 07:07 AM, Henrik Nordstrom wrote:
> Just a comment on why the tcp port match hotdrops "too small" packets:

Thanks for the explanation.

What is the best way to log these then?
Perhaps modify the dropped table patch to catch hotdrops?
