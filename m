From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH}: Make MARK target terminate (resend)
Date: Thu, 4 Jul 2002 01:50:55 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200207040150.55236@henrik.marasystems.com>
References: <Pine.LNX.4.33.0207031255220.17202-100000@blackhole.kfki.hu> <200207032041.49134.fabrice@celestix.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: fabrice@celestix.com
In-Reply-To: <200207032041.49134.fabrice@celestix.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wednesday 03 July 2002 14.41, Fabrice MARIE wrote:

> I proposed the last one some time ago. A solution to the ordering
> issue is to have two kind of targets:
> 1- terminal target (ie ACCEPT, DROP, REJECT, jump to chain, etc...)
> 2- non terminal target (ie TTL, MARK, IPV4OPTSSTRIP, etc...)
> The userland would basically use the order the admin provide,
> and would reply with an error if a non-terminal target is used
> after a terminal target.
>
> But I was answered that it was impossible/difficult with the
> current framework (which I agree).

Not really. To address this in the current framework one only needs to 
piggyback on the match list.

The kernel components needs to be modified to register themselves as 
matches as well as targets.

The userspace components needs to be extended with a additional flag 
telling the userspace tool that the "target" is a non-terminal target 
and can be installed as a match in the kernel space table if multiple 
targets are used.

The same datatypes should be possible to use for both the match info 
and the target info.

> I was also answered that it would break what people are used to,
> (having only one target) which I don't really agree with.

Neither do I.

Regards
Henrik
