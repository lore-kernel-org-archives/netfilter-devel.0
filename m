From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: string match patch
Date: Mon, 12 Jul 2004 23:51:10 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0407122348430.23090-100000@filer.marasystems.com>
References: <005501c46824$c2c0e7b0$0200a8c0@milchreis>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick <patrick_@freenet.de>
In-Reply-To: <005501c46824$c2c0e7b0$0200a8c0@milchreis>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 12 Jul 2004, Patrick wrote:

> after I patched it I noticed that I dont have any
> new menu point nor do I have CONFIG_IP_NF_MATCH_STRING in my kernel
> config .. the patch pretends to be applied correctly, which I can also
> verify, because the header files are present.

You SHOULD have a new menu entries for the string match..

    dep_tristate '  String match support (EXPERIMENTAL)' CONFIG_IP_NF_MATCH_STRING $CONFIG_IP_NF_IPTABLES

If you do not, and or else do not have CONFIG_IP_NF_MATCH_STRING defined
in your kernel configuration then the string match won't be build, and 
hence won't work.

Which version of pom-ng are you using?

Regards
Henrik
