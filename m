From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: how to release resource when rule is deleted {Virus Scanned}
Date: Thu, 29 Apr 2004 20:03:48 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404292002100.30100-100000@filer.marasystems.com>
References: <200404291514.i3TFEIPW008962@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Qiang <qzhang@endeavorsystems.net>
In-Reply-To: <200404291514.i3TFEIPW008962@localhost.localdomain>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 29 Apr 2004, Qiang wrote:

> If I have a match or target which will need to initialize some memory
> resource at check_entry,   can I have a chance to release the resource when
> the rule is deleted?

matches and targets have a destroy function which can be used for this
purpose.

Regards
Henrik
