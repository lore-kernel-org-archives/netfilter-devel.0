From: James Morris <jmorris@intercode.com.au>
Subject: Re: problem with libipq and userprocess and 'clean' exit
Date: Thu, 13 Jun 2002 21:50:18 +1000 (EST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <Mutt.LNX.4.44.0206132148020.5321-100000@blackbird.intercode.com.au>
References: <3D08719C.7020204@avodaq.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: =?ISO-8859-15?Q?Tassilo_Sch=FCtz?= <tschuetz@avodaq.com>
In-Reply-To: <3D08719C.7020204@avodaq.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 13 Jun 2002, [ISO-8859-15] Tassilo Schütz wrote:

> Hello list,
> 
> 
> I would like to know, if I have to do anything else, before quit my 
> userprocess? Is there
> maybe a flush_queue() call or term_queue() call? I thought about, 
> because of Queue flushing
> and Queue terminate in /proc/net/ip_queue.

Nothing to worry about, there is currentl no way for the ip_queue module 
to know that the user process has exited (unless another process starts 
using the queue).

The kernel module also ensures that all packets are fed back into the 
stack, no matter what the userspace application does.


- James
-- 
James Morris
<jmorris@intercode.com.au>
