From: Michael Rash <mbr@cipherdyne.com>
Subject: string match and hex strings
Date: Fri, 28 Feb 2003 20:05:34 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030228200534.B22879@orthanc.gambrl01.md.comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

My patch to libipt_string.c may introduce a slight problem which I
would like to bring up to the list and ask for input.

Any new version of iptables that contains the patch will allow
hex chars to be mixed within ascii strings in the "--string"
option:

iptables -A INPUT -m string --string "|45 45|blah" -j LOG

The problem is that all old versions of iptables will also accept
the same "|45 45|blah" string, but the hex chars won't mean
anything; it will just be treated as ascii data.  So we descend
into version problems...

My thought is that perhaps it would be better to reinstate my
original "--hex-string" option and leave the "--string" option to
just take input as-is.  The --hex-string option would be flexible
in the same way the patch is by allowing hex and ascii chars to
be mixed.

What do people think?

--Mike

Michael Rash
http://www.cipherdyne.com
Key fingerprint = 53EA 13EA 472E 3771 894F  AC69 95D8 5D6B A742 839F
