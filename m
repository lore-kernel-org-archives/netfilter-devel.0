From: Wang Jian <lark@linux.net.cn>
Subject: Re[2]: new REBOOT target
Date: Tue, 01 Mar 2005 17:49:21 +0800
Message-ID: <20050301173801.C851.LARK@linux.net.cn>
References: <20050301131208.C848.LARK@linux.net.cn>
	<4224265E.5050309@entri.com.ua>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Andrew Kozachenko <andrew@entri.com.ua>
In-Reply-To: <4224265E.5050309@entri.com.ua>
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

Hi Andrew Kozachenko,


On Tue, 01 Mar 2005 10:22:54 +0200, Andrew Kozachenko <andrew@entri.com.ua> wrote:

> >>    
> >>
> Why don't you use snmp trap for this purpose. You can send special snmp 
> trap from wherever to machine needs rebooting and running snmptrapd and 
> reboots it in a traphandle script.
> Consider using net-snmp for this not netfilter.
> 
> >

Because, in this case, user space programs have no chance to run
correctly, only kernel space has chance to do something, for example,
calling machine_restart();

I suspect that some program is hogging the memory system, and system is
busy swapping to death, but I can't make sure that because the console
is locked in this situation. Before I find the culpit, I have to reboot
it when the system is stuck.



-- 
  lark
