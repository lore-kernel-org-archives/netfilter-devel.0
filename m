From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: [RFC} handling closed sockets from netfilter
Date: Thu, 6 Jun 2002 11:38:47 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020606093847.GA18130@balabit.hu>
References: <OFA3A99B81.D3E9DBC4-ON80256BD0.00343BDE@portsmouth.uk.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Andy Whitcroft <APW@uk.ibm.com>
Content-Disposition: inline
In-Reply-To: <OFA3A99B81.D3E9DBC4-ON80256BD0.00343BDE@portsmouth.uk.ibm.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jun 06, 2002 at 10:31:21AM +0100, Andy Whitcroft wrote:
> 
> Somewhat arbritrary, but perhaps calling the callback release would match
> its meaning and the calling graph better.

ok, callback renamed to release. My implementation is now in place, and I'm
compiling the kernel right now.

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
