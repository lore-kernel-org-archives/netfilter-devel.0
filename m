From: Dan Purcell <dpurcell@nitrosecurity.com>
Subject: NFLOG --nflog-group bug?
Date: Fri, 16 Mar 2007 17:00:05 -0600
Message-ID: <45FB2175.1050503@nitrosecurity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I may have found a bug with the NFLOG target.  I am trying to use NFLOG
to log packets to a ulogd program using ip6tables.  I am using iptables
version 1.3.7, and linux kernel version 2.6.20.

I want to use the nflog-group number 32 for the system I have set up.
This is how I am using ip6tables:

      ip6tables -A FORWARD -j NFLOG --nflog-group 32

However, when I do an ip6tables -nvL FORWARD, I see this (note the
nflog-group number):


Chain FORWARD (policy ACCEPT 414 packets, 44089 bytes)
 pkts bytes target  prot opt in  out  source    destination
  112 11744 NFLOG   0        *   *    ::/0      ::/0     nflog-group 0



I was scratching my head why the nflog-group was 0, when I explicitly
told it to use group number 32.  I tried other numbers, such as 31, 30,
and 17, and they all displayed a nflog-group number of 0 after I printed
my ip6tables.  However, ip6tables was printing the correct value when I
 set the group number to 1, 4, 6, and 16.

Looking at the source code for libip6t_NFLOG.c, I see this in the parse
function:

      int n;
      ...
      n = atoi(optarg);
      if (n < 1 || n > 32)
         exit_error(PARAMETER_PROBLEM,
               "--nflog-group has to be between 1 and 32");
      info->group = 1 << (n - 1);
      printf("n is %d, Group is: %u\n", n, info->group);
      break;

The code tells me that any group between 1 and 32 (inclusive) is a
legitimate group number.  I know that the old ULOG target had the same
rules for its group number.  However, the data structure that defines
'info' (in the kernel's include/linux/netfilter/xt_NFLOG.h
file), I see this definition for info->group:

      struct xt_nflog_info {
         u_int32_t   len;
         u_int16_t   group;
         u_int16_t   threshold;
         u_int16_t   flags;
         u_int16_t   pad;
         char     prefix[64];
      };

'group' here is a 16-bit integer.  In effect, the highest nflog-group
that I can potentially achieve is 16, not 32.  Should the 'group' in
'struct xt_nflog_info' be a u_int32_t, and take out the 'u_int16_t pad'?

- -Dan
- --

- --------------------------------------------------------------
Dan Purcell, Software Engineer     dpurcell@nitrosecurity.com
NitroSecurity, Inc.                            (208) 552-5332
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFF+yF1Tqu8TzII/vURAqpGAJ9NI4LFAADeRmCYSRSH8Mr1yWt9hACeICuX
VCVUGiUQlT9AId6ddQVJi7Q=
=/OTu
-----END PGP SIGNATURE-----
