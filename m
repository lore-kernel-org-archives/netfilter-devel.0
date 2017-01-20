From: Paul Moore <paul@paul-moore.com>
Subject: Re: AUDIT_NETFILTER_PKT message format
Date: Fri, 20 Jan 2017 15:37:12 -0500
Message-ID: <CAHC9VhT8QQ2inKgJ_ZAeiEOvmnjv-0AbHjrRf-LGfUT+WMFUeQ@mail.gmail.com>
References: <20170117052551.GQ3087@madcap2.tricolour.ca>
	<20170118151520.GY3087@madcap2.tricolour.ca>
	<CAHC9VhS_6Q=bxnzU8ni1a2fRWnXoMcELzAmy0HmwMH_xhgfRBw@mail.gmail.com>
	<21839828.eXAB1nqvpV@x2>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Richard Guy Briggs <rgb@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>,
        Thomas Graf <tgraf@infradead.org>
To: Steve Grubb <sgrubb@redhat.com>
Return-path: <linux-audit-bounces@redhat.com>
In-Reply-To: <21839828.eXAB1nqvpV@x2>
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-audit>
List-Post: <mailto:linux-audit@redhat.com>
List-Help: <mailto:linux-audit-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=subscribe>
Sender: linux-audit-bounces@redhat.com
Errors-To: linux-audit-bounces@redhat.com
List-Id: netfilter-devel.vger.kernel.org

On Fri, Jan 20, 2017 at 9:49 AM, Steve Grubb <sgrubb@redhat.com> wrote:
> On Wednesday, January 18, 2017 6:35:29 PM EST Paul Moore wrote:
>> At this point I think it would be good to hear what requirements exist
>> for per-packet auditing.  Steve, are there any current Common Criteria
>> (or other) requirements that impact per-packet auditing?
>
> I don't think you want to flood your logs. That is not helpful. It asks for the
> ability to detect information flow. Typically you want to know source and
> destination, protocol, where on the system its coming from or going to, pid if
> possible and the subject information if available. I know that you can be
> acting as a proxy and forwarding outside packets into a network. That is not
> the typical case CC is concerned about. Its more about what the user is doing.

Determining the pid/subj of a packet is notoriously
difficult/impossible in netfilter so let's drop that; with proper
policy/rules you should be able to match proto/port with a given
process so this shouldn't be that critical.  The source/destination
addresses and proto/port (assuming IP) should be easy enough.

All right, now that we've got the "must" items down, are their any
"should" items we want?

-- 
paul moore
www.paul-moore.com
