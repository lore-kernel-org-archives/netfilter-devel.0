From: jones.ian@comcast.net ("Ian Jones")
Subject: Re: libipq and timestamp
Date: Mon, 18 Aug 2003 19:37:47 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <r83i4h44.fsf@comcast.net>
References: <1061213776.21582.9.camel@tech004.alphalink.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Eric Leblond <eric@regit.org>
In-Reply-To: <1061213776.21582.9.camel@tech004.alphalink.fr> (Eric Leblond's
 message of "18 Aug 2003 15:36:17 +0200")
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


Eric Leblond <eric@regit.org> writes:

> I did not manage to get the timestamp of a packet in the message given
> by libipq. It is just 0.
> Is there something to do to have it fill in ?

If the packet is locally generated then the timestamp is not filled
in for you. Here is a snippet that may help:

 /* locally generated?, no timestamp */
  if (!m->timestamp_sec)
    {
      memset (&tz, 0, sizeof (tz));
      gettimeofday (&tv, &tz);
      ph.ts.tv_sec = tv.tv_sec;
      ph.ts.tv_usec = tv.tv_usec;
    }
  else
    {
      ph.ts.tv_sec = m->timestamp_sec;
      ph.ts.tv_usec = m->timestamp_usec;
    }

-----BEGIN PGP SIGNATURE-----
Comment: Keeping the world safe for geeks.

iD8DBQE/QXFbwBVKl/Nci0oRAt91AJwMLTu43iFjrtAyAj4fGG2nvYK2pwCg7RgH
ym7QrHv/NkFEa3Q/semyoS4=
=fwjd
-----END PGP SIGNATURE-----
