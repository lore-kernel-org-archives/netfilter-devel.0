From: Menno Smits <menno@netbox.biz>
Subject: Re: PPTP connection tracking and Poptop on same box
Date: Fri, 05 Sep 2003 10:21:31 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F57D70B.3040307@netbox.biz>
References: <3F542C4E.1000307@netbox.biz> <Pine.GSO.4.56.0309031853090.10914@shemp.vdata.com> <3F56E2E2.5040007@netbox.biz> <Pine.GSO.4.56.0309040327250.10914@shemp.vdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
In-Reply-To: <Pine.GSO.4.56.0309040327250.10914@shemp.vdata.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Jeff Hall wrote:

>   > I checked the patches in your posts against a POM patched 2.4.20 kernel
>   > I used to use here which exhibits the same problems as my 2.4.21 kernel.
>   > I can't even find where your patches to ip_conntrack_pptp.c could be
>   > applied! (even when trying to apply the patch manually). Key lines which
>   > surround your changes simply don't exist in my tree. I was using POM out
>   > of CVS from a few months ago in that kernel. What POM version are you
>   > using? Which POM patches are you using?
>   >
> I started with the 20030107 POM but then added individual patches I
> needed from the CVS archives. I tried to detail them as clearly as possible
> in the March 2nd and 3rd memos. I'm afraid that is the best I can do now
> after 6 months.  I'll send you the fully patched sources I'm using in a
> personal message. I hope you find them useful. I'll send you anything
> dated newer than when I ran the 20030107 POM against the 2.4.20 base.

Thanks for trying to remember. I appreciate that asking you to remember
what obscure patches you used 6 months ago is a bit of an ask :)

I've received the sources and will give them a go.

Some other interesting findings:
I tested connections to Poptop further yesterday. This time I connected
via a 1.5Mbps Internet link rather than the 100Mbps LAN that I've been
using for previous testing. Connections via this link were much more
likely to work! I think the higher latency of the link may have
something to do with it. This re-enforces my statement in the first
message of this thread that the problem might be timing related.

>   > Actually the MTU/MRU/TCPMSS stuff was to deal with "GRE: Discarding
>   > duplicate packet" problems not 'out of order packet" problems like I
>   > originally stated (it was a while ago). I removed these workarounds
>   > today just to make sure that these had nothing to do with the problems
>   > I'm having. Connection attempts seemed to behave in just the same way
>   > (unreliably), and I started getting lots of "GRE: Discarding duplicate
>   > packet" messages when a connection did establish and data was transferred.
>   >
> I consistently receive one "GRE: Discarding duplicate packet" message per
> connection. But it never causes any problem so I've never pursued the cause.
> I see on Sourceforge that the single message problem is due to an initial-
> zation error in pptpgre.c (see the diff 1.4 vs 1.3). I've never had a problem
> with multiple "duplicate..." errors. Possibly they are due to the kernel
> delivering GRE packets to the wrong pptpd process.

I'm not sure what exactly is behind the duplicate packet messages but
lowering the MTU, MRU and TCPMSS definitely makes them go away. It also
seems to improve performance somewhat. At some sites I found that file
transfers would grind to a halt with huge numbers of duplicate packet
messages being logged unless the MTU etc was lowered.

Thanks again.

Menno
