From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: Using Netfilter hooks - how to log connection attempts?
Date: Mon, 12 Apr 2004 19:50:52 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200404121950.52791.thomas.jarosch@intra2net.com>
References: <Pine.LNX.4.44.0404121941420.3467-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.44.0404121941420.3467-100000@filer.marasystems.com>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> > How can I keep a track of connection attempt form each IP?
>
> You need some kind of registry for this. As the size may grow rather large
> I would recommend sending the details to userspace, but you may obviously
> also keep the registry in your kernel module..

Guess the "recent" module might be a good place to look
if you want to do this in kernel space.

Thomas
