From: Anders Fugmann <afu@fugmann.dhs.org>
Subject: Re: remove usage of __MOD_XXX_USAGE_COUNT and derivatives
Date: Fri, 10 Jan 2003 14:49:31 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E1ECF6B.5080109@fugmann.dhs.org>
References: <3E1DEF2D.4080703@fugmann.dhs.org> <20030110131315.GS1353@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20030110131315.GS1353@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte wrote:
> On Thu, Jan 09, 2003 at 10:52:45PM +0100, Anders Fugmann wrote:
> 
> Ok, this seems to be some new 2.5.x api changes - I first need to get
> familiar with this.
Most of the documentation I found in include/linux/module.h.

> 
> 
>>Conversion enables module unloading on 2.5 kernels.
>>The patch is against 2.5.55. I have only tested ipv4 functionality, and 
>>I see no reason that ipv6 shound not work also.
One thing I have noticed is that the module usage count for 'ip_tables'
gets incremented twice when loading a module that depends on the
ip_tables module. Unloading the module again also decrements usage count
on ip_tables with 2. This happens both on vanilla 2.5.55 and 2.5.55 with 
the patch applied. It does not happen on 2.4.20 though.

One question. Why is the module count increased (code wise) whenever a 
new module is loaded, that depends on the current module? Eg. When 
loading ipt_MARK, the module count for ip_tables is increased. The 
dependancies are still kept by the kernel so ip_tables cannot be 
unloaded anyhow.

> So if the patch is accepted (still need to look at it), I will submit it
> for kernel inclusion. 
Then I send it to the right place it seems.

Regards
Anders Fugmann.
