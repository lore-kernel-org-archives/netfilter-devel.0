From: "miguel Angel Vazquez" <mikinho21@gmail.com>
Subject: development with queues
Date: Tue, 18 Apr 2006 11:53:29 +0200
Message-ID: <f015bcab0604180253m76a8d960q5c7b6d821401927e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi all.

we are trying to develop an application which has to reduce some
headers from an intercepted packet (some HTTP headers in order to
optimize an UMTS uplink channel).

I have read some howtos and I think it can be possible to do that.
As i Have understand, the packet remains queued and I can process it
in user-space or in kernel-space, but I'm not sure about what the
packet "status" is....it has all the IP and TCP headers?Can I modify
the HTTP packet??

Thanks mates!
(sorry for my English)
