From: =?ISO-8859-1?Q?Tassilo_Sch=FCtz?= <tschuetz@avodaq.com>
Subject: Re: problem with libipq and userprocess and 'clean' exit
Date: Fri, 14 Jun 2002 15:40:50 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <3D09F262.6080104@avodaq.com>
References: <Mutt.LNX.4.44.0206132148020.5321-100000@blackbird.intercode.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: James Morris <jmorris@intercode.com.au>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

James Morris schrieb:

>Nothing to worry about, there is currentl no way for the ip_queue module 
>to know that the user process has exited (unless another process starts 
>using the queue).
>
>The kernel module also ensures that all packets are fed back into the 
>stack, no matter what the userspace application does.
>
>
>- James
>  
>
Thank you for the information.

best regards

Tassilo
