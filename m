From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: [RFC] how to write static int parse(...) function
Date: Sat, 15 Jun 2002 15:11:44 +0200 (CEST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <Pine.LNX.4.21.0206151504090.16282-100000@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

I am writing options to the unclean module, so that we can:
-m unclean --tcp, -m unclean ! --udp, etc.

I have the kernelspace additions written.
The userspace libipt_unclean.c need rewriting, and here i come across a
problem:
i do not know what all the functions and variables there mean.
like, flags, nfcache, invert, check_invert.

I have been browsing through the other modules, and i think i know what
flags and parse function does. But i would like some comments on how
should this be written.

As of now i am able to write it so it accepts options, but not inverted.
In a nutshell, i want it to accept:
--ip         matches all ip checks
--ip-check1  matches ip check1
--ip-check2

--tcp        matches all tcp chceck
--tcp-check1 matches tcp check1

...

Also if I knew how to do this i would be able to finish it before feature
freeze announced by Harald.

Best Regards,
Maciej Soltysiak
