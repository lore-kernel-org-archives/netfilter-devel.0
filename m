From: Patrick Schaaf <bof@bof.de>
Subject: Re: Buffer of by one in iptables.c in iptables v1.2.7a
Date: Sun, 23 Feb 2003 12:41:50 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030223114150.GF18918@oknodo.bof.de>
References: <200302211624.05704.arvanit@ellemedia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Arvanitis Kostas <arvanit@ellemedia.com>
Content-Disposition: inline
In-Reply-To: <200302211624.05704.arvanit@ellemedia.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, Feb 21, 2003 at 04:24:05PM +0200, Arvanitis Kostas wrote:
> The line in find_target() that reads:
> 
> char path[sizeof(IPT_LIB_DIR) + sizeof("/libipt_.so") + strlen(name)]
> 
> is used as the target buffer for a sprintf() statement.

That is probably correct, although a bit subtle.

You did not show the format string used later, and I'm too lazy do
dig for the source, but I guess it will be something like

	sprintf(path, IPT_LIB_DIR "/libipt_%s.so", name);

Right?

Now, count the characters again, with an eye not on the path[sizeof]
stuff, but on the actual format string. Note how the value of 'name'
will be embedded in the formatted string: it does not need a '\0' in
that representation.

Also note that the two sizeofs each contribute one '\0' (their args
being constant C strings), but only one of them is needed for
sprintf() to properly terminate the result. So, if I don't
miscount, there's even one surplus byte in path[].

This should fix that:

	char path[sizeof(IPT_LIB_DIR "/libipt_.so") + strlen(name)]

best regards
  Patrick
