From: Max Kellermann <max@duempel.org>
Subject: Re: [RFC] h323 module unloading fix
Date: Wed, 9 Feb 2005 10:10:23 +0100
Message-ID: <20050209091023.GA6830@roonstrasse.net>
References: <20050208145908.GS6878@sunbeam.de.gnumonks.org>
	<420946FF.107@trash.net>
	<20050209082459.GY6878@sunbeam.de.gnumonks.org>
	<Pine.LNX.4.58.0502090933250.2846@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0502090933250.2846@blackhole.kfki.hu>
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

On 2005/02/09 09:59, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:
> I like Patrick's idea. There are not so many modules wich rely on
> unregistered helpers, and we could retain backward compatibility in the
> API like in the attached (untested) patch. What do you think?

Calling an "evicting" function in a module destructor for something
which the netfilter core didn't even know about until now doesn't look
elegant to me. For me, to every destructing function, there must be a
prior constructor call.

There is no compatibility problem with Harald's/my solution. My
proposition allows the "register_helper" function to register
"disabled" helpers, meaning that you have to both register and
unregister the H.245 helper.

If we ever decide that it is required to register "disabled" helpers,
we don't have to change the API again, and it costs us near to nothing
to instruct that now.

It does not matter if "register_helper" ignores disabled helpers for
now, and "unregister_helper" works like the "evicting" function
Patrick proposed; we can change internals like this any time we want
without having to touch modules again.

Max
