From: Patrick Schaaf <bof@bof.de>
Subject: Re: conntrack performance/DoS formula
Date: Tue, 2 Jul 2002 08:05:01 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020702080501.B7684@oknodo.bof.de>
References: <20020701121404.B78724512@lists.samba.org> <15648.51711.918456.294773@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Don Cohen <don-nf@isis.cs3-inc.com>
Content-Disposition: inline
In-Reply-To: <15648.51711.918456.294773@isis.cs3-inc.com>; from don-nf@isis.cs3-inc.com on Mon, Jul 01, 2002 at 02:30:39PM -0700
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Don,

> And now, since I think this is a useful approach it's worth while to
> mention the following:

I'm doing some gnuplot pictures right now, and crc32 really does come
out as preferrable regarding list length distributions for varying
bucket sizes. I'll post a link to a presentation of that analysis
later today.
 
[regarding the hash_crc32() in my test program]
> 
> Isn't that the same (modulo order of data) as this?
>      return crc32(crc, (const char *) key, sizeof(struct ct_key)); 

The problem with this is not so much order of data, which would be
the same for all calls on a local machine (i.e. at least consistent).
The problem is possible padding in the structure. While such padding
in the real in-kernel tuple data structure would be space wastage,
it _is_ possible in principle for a C compiler to introduce such padding.

> On my 200MHz machine
>  your crc    my change	hash_conntrack
>  1.5usec     1.1usec    .2usec		   gcc -o cttest cttest.c
>  1.1usec     .53usec    .14usec		   gcc -O9 -o cttest cttest.c

I'm sure that there's much more speed to be had over the crc32() function
I borrowed from zlibc. That one is a general N-byte crc32, and here we
always have a fixed amount of bytes. Thus, for production, we would look
into completely unrolling the crc32 loop. I'll look into microoptimizating
this if and only if it is decided to have crc32 as a (possibly alternative)
hash function for conntrack. It's not worth the effort for the test program
alone.

Thanks nevertheless for bringing this up; it is an important issue when
we want to deploy crc32.

best regards
  Patrick
