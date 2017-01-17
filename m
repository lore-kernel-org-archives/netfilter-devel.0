From: Paul Moore <paul@paul-moore.com>
Subject: Re: AUDIT_NETFILTER_PKT message format
Date: Tue, 17 Jan 2017 15:17:47 -0500
Message-ID: <CAHC9VhT7aR1hHfDyU-r6QXTV92rEx1x8s7cH66bzh8FiDv24eQ@mail.gmail.com>
References: <20170117052551.GQ3087@madcap2.tricolour.ca>
	<3051394.ngqbNXneNL@x2>
	<20170117161228.GS3087@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>,
        Thomas Graf <tgraf@infradead.org>,
        Linux-Audit Mailing List <linux-audit@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Return-path: <linux-audit-bounces@redhat.com>
In-Reply-To: <20170117161228.GS3087@madcap2.tricolour.ca>
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

On Tue, Jan 17, 2017 at 11:12 AM, Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2017-01-17 08:55, Steve Grubb wrote:
>> On Tuesday, January 17, 2017 12:25:51 AM EST Richard Guy Briggs wrote:

...

>> > Ones that are not so straightforward:
>> > - "secmark" depends on a kernel config setting, so should it always be
>> >   present but "(none)" if that kernel feature is compiled out?
>>
>> If this is selinux related, I'd treat it the same way that we do subj
>> everywhere else.
>
> Ok.

To be clear, a packet's secmark should be recorded via a dedicated
field, e.g. "secmark", and not use the "subj" field (it isn't a
subject label in the traditional sense).

-- 
paul moore
www.paul-moore.com
