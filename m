From: Patrick Schaaf <bof@bof.de>
Subject: Re: Help me ,Help me .
Date: Sat, 26 Apr 2003 08:05:03 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030426060503.GB7766@oknodo.bof.de>
References: <000c01c30bb1$ad85a640$01e7a8c0@zpeak>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: cyberyam <zpeak@cyberyam.com>
Content-Disposition: inline
In-Reply-To: <000c01c30bb1$ad85a640$01e7a8c0@zpeak>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello, unnamed entity calling itself 'cyberyam' and 'zpeak',

> I coun't call the system call ,example sys_open ,sys_close, 
> The problem is i could't write file ,what can i do ,

You can learn that the kernel is not user mode. There's an awful lot to learn.

Iptables kernel modules do not run in process context, so you are not able
to do any filesystem I/O from them.

If you do not understand the answer, see/ask http://www.kernelnewbies.org/

>From your example code, I gather that you want to send an email when
some condition happens. See the existing, well established 'ULOG' target
for a working, proper approach to that task. No need for kernel programming,
as far as I can tell. See http://gnumonks.org/projects/ulogd

regards
  Patrick
