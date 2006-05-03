From: "=?ISO-8859-1?Q?S=E9bastien_LAVEZE?=" <slaveze@gmail.com>
Subject: Re: Libnetfilter_conntrack problems
Date: Wed, 3 May 2006 11:49:04 +0200
Message-ID: <ca021ab30605030249s62ab1924uf9b1be924bd2d28e@mail.gmail.com>
References: <ca021ab30604270455q5cf093c9s990558209bca3e1d@mail.gmail.com>
	<20060501175353.GD5267@rama>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Harald Welte" <laforge@netfilter.org>
In-Reply-To: <20060501175353.GD5267@rama>
Content-Disposition: inline
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

OK
I was trying to have multiple handles in different threads and it was
working only for the first created thread. I change my application in
a multi-process one and all seems to work fine
However the DESTROY events come a long time after the actual end of a
connection by timeout...am I right ?

Thanks
Sebastian

On 5/1/06, Harald Welte <laforge@netfilter.org> wrote:
> On Thu, Apr 27, 2006 at 01:55:13PM +0200, S=E9bastien LAVEZE wrote:
> > but not for destroy =3D=3D> nfct_open(CONNTRACK,
> > NF_NETLINK_CONNTRACK_DESTROY), i never get any event
>
> are you sure?  did you wait until the respective entries really timed
> out from the conntrack table?
>
> what does 'conntrack -E -e DESTROY' say?  do you then see the events?
>
> > 2) I also would like to work with ids, when i get a conntrack via a
> > callback the id field is always set to zero, is it normal ?
>
> IIRC, we dropped ID's recently. I'm a bit lagging behind, though.
>
> --
> - Harald Welte <laforge@netfilter.org>                 http://netfilter.o=
rg/
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
>   "Fragmentation is like classful addressing -- an interesting early
>    architectural error that shows how much experimentation was going
>    on while IP was being designed."                    -- Paul Vixie
>
>
>
