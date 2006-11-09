From: "J. Federico Hernandez" <fede.hernandez@gmail.com>
Subject: Re: [announce] pyctd 0.1, a connection tracking XML-RPC server
Date: Thu, 9 Nov 2006 11:56:31 -0300
Message-ID: <c0db55360611090656t482cb4f0rc28fe70432765430@mail.gmail.com>
References: <1162999883.8096.27.camel@localhost.localdomain>
	<45523335.3060604@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Pablo Neira Ayuso" <pablo@netfilter.org>
In-Reply-To: <45523335.3060604@netfilter.org>
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

Hi Pablo,

On 11/8/06, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Eric Leblond wrote:
> > INL devel team is proud to announce the availability of pyctd, PYthon
> > Conntrack Daemon.
> >
> > pyctd is a XML-RPC service for monitoring and altering Netfilter
> > connections tracking for network admins.
>
> It seems that you are producing interesting stuff for sysadmins.
>
> > It has the following functionnalities :
> >       * Connection listing (with byterate of each connections)
>
> So, I assume that you are dumping the conntrack every N seconds, I'd
> like to know what is the impact of this in terms of performance on a
> busy firewall (lots of conntrack entries).
>
> >       * Entries removal
> >       * Modification of connection mark and timeout
> >
> > pyctd is a free software released under GNU General Public License.
>
> I don't know if you had the chance to have a look at conntrackd, its
> statistics mode is still poor but can be improved quite easily. I want
> to implement conntrack dumping in XML format via conntrackd, this can be
> interesting for 3rd party apps. My impression is that this daemon would
> look very similar to mine, so would you consider integrating this with
> conntrackd?

Do you know JSON? It is a lightweight data-interchange format.
With this text format is easier to implement and to use a JSON parser
than to use a XML parser. JSON has the same XML's advantages, but not
its disadvantages.
JSON is data oriented, however XML is document oriented.

If you are thinking about comunication with other apps, maybe it is
more useful that you use this format to exchange data between
conntrackd and other apps.

This is just a suggestion.

More info about JSON in www.json.org.

Regards,

-- 
Federico
