From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: How to build a new tarjet ?
Date: Wed, 30 Jul 2003 21:33:52 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0307302119350.14762-100000@filer.marasystems.com>
References: <FE1B8578-C2BC-11D7-A544-000A95A021F6@cse.ogi.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Antoine Luu <aluu@cse.ogi.edu>
In-Reply-To: <FE1B8578-C2BC-11D7-A544-000A95A021F6@cse.ogi.edu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 30 Jul 2003, Antoine Luu wrote:

> I want use netfilter/iptables to create a new target. I read the 
> netfilter-hacking-HOWTO, and I know how to make the kernel module but I 
> can not find any information about iptables hacking (how to program the 
> libipt_*.c ?).

Trying to remember where I looked the first time, but I can't remember..  
In any event it is very simple.  I think I just used one of the existing
smaller ones as template.

All the libipt_*.c does is converting arguments to/from the kernel
structure for the target/match in three different formats and most also
validate the data the data to give sane error reporting beyond "an error
occured". There is also a little framework for registering command line
options, providing help messages etc.

  * Command line input   (iptables -A & iptables-restore)
  * Command line output  (iptables-save)
  * View output (iptables -L)

When you are done with your userspace glue remember to make a .<name>-test
file for determining if your kernel component is available in the kernel
sources, and your user space glue will be automatically picked up by the
make files.


The basic structure is

struct iptables_target, providing hooks to all the differen operations. 
Most are self-explanotary I think.

The iptables_target also provides a list of command line flags supported 
by the module.

The _init function is responsible for automatically registering the target
when the userspace module is loaded. All other symbols are internal to the 
module itself (static).

Regards
Henrik
