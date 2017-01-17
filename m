From: Richard Guy Briggs <rgb@redhat.com>
Subject: AUDIT_NETFILTER_PKT message format
Date: Tue, 17 Jan 2017 00:25:51 -0500
Message-ID: <20170117052551.GQ3087@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Thomas Graf <tgraf@infradead.org>
To: Linux-Audit Mailing List <linux-audit@redhat.com>,
        Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <linux-audit-bounces@redhat.com>
Content-Disposition: inline
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

Hi,

I'm just starting to look at the normalization of AUDIT_NETFILTER_PKT
event messages and it is not quite as straightforward as I had expected.

It is being tracked here:
	https://github.com/linux-audit/audit-kernel/issues/11
and refers to a previous posting from Mr. Dash Four from four years ago
to which there was no reply.

The example given in the tracker above for "frag=" is fairly
straightforward, but digging more, there are a number of others that are
not quite so obvious.

How many different combinations of fields is acceptable?  Can we create
new message types for each one, or is there a preferred way to indicate
which sub-type it is other than implicit from the arguments given?

Others that are straightforward:
- The first "truncated=" gets pulled in with "0".

- "mark=" gets pulled in with "0".

Ones that are not so straightforward:
- "secmark" depends on a kernel config setting, so should it always be
  present but "(none)" if that kernel feature is compiled out?

- ARPHRD_ETHER pulls in 3 fields, I would pull them all in and set them
  to "(none)" to indicate that type isn't present.

- audit_ip4() and audit_ip6 share "saddr=", "daddr=", proto=", but ip4
  adds "ipid=", which would be set to "(none)" for ip6.

- audit_proto() pulls in "truncated=" again, then either "sport=" and
  "dport=" OR "icmptype=" and "icmpcode=".

If all fields are pulled in, we end up adding 10 fields beyond a
standard well-formed packet, and 15 beyond a truncated packet.

Note: In the cases of "mark" and "secmark" both are unions.  In the case of
"mark", I don't see a problem since it isn't conditionally compiled out
and won't be mis-interpreted.  In the case of "secmark=", it could be
mis-interpreted as offload_fwd_mark if that field is even compiled in,
but that would be addressed in the compiler directive...


One last question: Does anyone have a test suite that can generate any
or all of these types of packets?


Thanks!


- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Kernel Security Engineering, Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635
