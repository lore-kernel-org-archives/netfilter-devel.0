From: tuXit <tuxit@netcourrier.com>
Subject: Re: New standalone nat helper module which help function is never
 called
Date: Tue, 18 Nov 2003 10:04:49 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031118100449.4815515b.tuxit@netcourrier.com>
References: <20031117174829.711e2e82.tuxit@netcourrier.com>
	<20031117223129.GF5075@sunbeam.de.gnumonks.org>
	<20031118005846.06befa0d.tuxit@netcourrier.com>
	<20031118004931.GH5075@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031118004931.GH5075@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 18 Nov 2003 01:49:31 +0100
Harald Welte <laforge@netfilter.org> wrote:

> On Tue, Nov 18, 2003 at 12:58:46AM +0100, tuXit wrote:
> > 	ascii.flags = IP_NAT_HELPER_F_STANDALONE;
> 
> you are missing IP_NAT_HELPER_F_ALWAYS here.  otherwise a nat helper
> will only be called if a connection tracking helper has issued an
> expectation within that packet.

That's true; I added this flag so now, I have :
ascii.flags = IP_NAT_HELPER_F_STANDALONE + IP_NAT_HELPER_F_ALWAYS;
I also changed 
char ascii_names[10];
that was in my previous post from the function 
__init 
outside of it (because it is in the stack, so deleted whenever this function
is finished).

But it still doesn't help. The function do_bindings from the file ip_nat.core
is called for each natted packet that is going toward port 119, but while
trying to detect the helper, it value is NULL. I tried to try to debug,
modifying the snmp nat helper module. I modified the udp fields into tcp
fields, and the udp protocol into tcp protocol, and exchange source and
destination. After these modifications in the 
struct ip_nat_helper
the helper function is not called anymore whenever a natted packet arrives. So
I don't understand what happens...

-- 
Florian Pouradier
echo '|^H_!Xn|^H_' | less 
EpX Member - Debian GNU/Linux user
GPG FP: B0D7 1F53 94DA 0BCA C11E  F417 094B 49F3 D5DD F5EC 
