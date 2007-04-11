From: "Mohammad Mohsenzadeh" <mmohsenz@gmail.com>
Subject: 2.6.20 support for other 'features'
Date: Wed, 11 Apr 2007 13:39:48 -0400
Message-ID: <e6af3bc80704111039x322e55e5qe1ea1568b59214b0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hello,

I have been developing extension for netfilter to allow stateful
firewall and filtering. I was looking at the new api in 2.6.20 and I
was wondering why the number of 'features' allowed is maxed to 4.

I was thinking of configuration number of features and maybe some way
of setting a default feature to use instead of NF_CT_F_BASIC. This way
the netfilter can easily be extended. I can provide a patch if you
think the above is a good idea.

Best regards

Mohammad
